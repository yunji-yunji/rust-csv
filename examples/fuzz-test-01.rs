use std::{error::Error, io, process};
use std::io::Read;
use csv_core::{ReadFieldResult, Reader};
use csv::{ReaderBuilder, WriterBuilder};

fn delimiter() -> Result<(), Box<dyn Error>> {
    // let delim = if thread_rng.gen_bool(0.5) { b'|' } else { b',' };
    // let delimiters = [b',', b';', b'\t', b'|', b':'];
    // let delim = if !data.is_empty() { data[0] } else { b',' };

    let mut rdr = ReaderBuilder::new()
        .has_headers(false)
        .delimiter(b'\t')
        .double_quote(false)
        .escape(Some(b'\\'))
        .flexible(true)
        .trim(csv::Trim::All)
        .comment(Some(b'#'))
        .from_reader(io::stdin());

    let mut wtr = WriterBuilder::new()
        .delimiter(b':')
        .from_writer(io::stdout());

    let _ = wtr.write_record(&["field1안", "fiel녕d2", "fi못해eld3"]);
    for result in rdr.records() {
        let record = result?;
        let _ = wtr.write_record(record.iter());
        // println!("{:?}", record);
    }
    let _ = wtr.flush();

    Ok(())
}

fn core_test1(mut data: &[u8]) -> Option<u64> {
    let mut rdr = Reader::new();

    let mut count = 0;
    let mut fieldidx = 0;
    let mut inus = false;
    let mut field = [0; 1024];
    loop {
        // Attempt to incrementally read the next CSV field.
        let (result, nread, nwrite) = rdr.read_field(data, &mut field);
        data = &data[nread..];
        let field = &field[..nwrite];

        match result {
            ReadFieldResult::InputEmpty => {}
            ReadFieldResult::OutputFull => {
                return None;
            }
            ReadFieldResult::Field { record_end } => {
                if fieldidx == 0 && field == b"us" {
                    inus = true;
                } else if inus && fieldidx == 3 && field == b"MA" {
                    count += 1;
                }
                if record_end {
                    fieldidx = 0;
                    inus = false;
                } else {
                    fieldidx += 1;
                }
            }
            // This case happens when the CSV reader has successfully exhausted
            // all input.
            ReadFieldResult::End => {
                break;
            }
        }
    }
    Some(count)
}

// 7 targets in total
fn example() -> Result<(), Box<dyn Error>> {
    // let mut rdr = csv::Reader::from_reader(io::stdin());
    let mut buffer = Vec::new();
    io::stdin().read_to_end(&mut buffer)?;
/*
    // 1. tutorial-read-basic.rs, tutorial-error-01.rs, ..
    // 2. tutorial-read-headers-02.rs
    let mut rdr = csv::Reader::from_reader(&buffer[..]);
    {
        let headers = rdr.headers()?;
        println!("{:?}", headers);
    }
    for result in rdr.records() {
        let record = result?;
        println!("{:?}", record);
    }

    // 3. tutorial-perf-alloc-02.rs
    // 4. tutorial-read-headers-01.rs
    // let mut rdr2 = csv::Reader::from_reader(&buffer[..]);
    let mut rdr2 =
        csv::ReaderBuilder::new().has_headers(false).from_reader(&buffer[..]);
    for result in rdr2.byte_records() {
        let record = result?;
        println!("{:?}", record);
    }

    // 5. tutorial-perf-alloc-03.rs
    let mut rdr3 = csv::Reader::from_reader(&buffer[..]);
    let mut record = csv::ByteRecord::new();
    let mut count = 0;
    while rdr3.read_byte_record(&mut record)? {
        count += 1;
    }
    println!("{}", count);
 */
    // 6. tutorial-perf-core-01.rs
    let mut data: &[u8] = &buffer[..];
    let res2 = core_test1(&mut data);
    println!("res2 = {:?}", res2);

    // 7. tutorial-read-delimiter-01.rs
    let res3 = delimiter();
    println!("res3 = {:?}", res3);
    Ok(())
}

fn main() {
    if let Err(err) = example() {
        println!("error running example: {}", err);
        process::exit(1);
    }
}
