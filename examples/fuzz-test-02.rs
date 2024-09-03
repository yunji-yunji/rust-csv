use std::{env::args, error::Error, path::PathBuf, process};

fn example(file_path: PathBuf) -> Result<(), Box<dyn Error>> {
    // Build the CSV reader and iterate over each record.
    let file = std::fs::File::open(file_path)?;
    let mut rdr = csv::Reader::from_reader(file);
    for result in rdr.records() {
        // The iterator yields Result<StringRecord, Error>, so we check the
        // error here..
        let record = result?;
        println!("{:?}", record);
    }
    Ok(())
}

fn main() {
    let file_path = args().nth(1).expect("expected path to CSV file");
    if let Err(err) = example(file_path.into()) {
        println!("error running example: {}", err);
        process::exit(1);
    }
}
