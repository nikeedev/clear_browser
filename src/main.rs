use std::{env, fs, process};
use colored::*;


fn main() {
    let version = "0.1.0a";

    let args: Vec<String> = env::args().collect();

    let file: String = if args.len() >= 2 {
        match fs::read_to_string(args[1].clone()) {
            Ok(x) => x,
            Err(x) => panic!("{}", format!("clear_browser: Error reading \"{}\", due to (stderr from system): {}", args[1], x).bold().italic().bright_red()),
        }
    } else {
        println!(
            "{}",
            format!("🪟 clear_browser - {} ", version).blue().on_white()
        );
        println!("{}", "\nUsage: clear_browser <file>.toml".bright_purple());
        process::exit(0);
    };

    let parsed = toml::from_str::<toml::Value>(&file).unwrap();

    println!("{:?}", parsed);
}
