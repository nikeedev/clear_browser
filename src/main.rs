use std::{env, fmt::Result, fs, process};
use colored::*;
use serde_json::Value;

#[derive(Debug)]
enum FontWeight {
    Light,
    Normal,
    Bold,
    Bolder,
}

#[derive(Debug)]
struct Style<'a> {
    color: &'a str,
    background_color: &'a str,
    font_family: &'a str,
    font_size: &'a str,
    font_weight: FontWeight,
    weight: i32,
    height: i32,
}

#[derive(Debug)]
struct Element<'a> {
    value: &'a str,
    selector: &'a str,
    style: Style<'a>,
}

#[derive(Debug)]
struct Clear<'a> {
    title: &'a str,
    // icon: &'a str, // will be added later to web sites
    elements: Vec<Element<'a>>,
    head_elements: Vec<Element<'a>>,
}

fn too_clear(v: &Value) -> Clear {
    let mut clear = Clear {
        title: "",
        elements: Vec::new(),
        head_elements: Vec::new(),
    };

    clear.title = v["head"]["title"].as_str().unwrap();

    v["body"].as_array().iter().for_each(|elem| {
        println!("{:?}", elem);
    });

    clear
}

fn main()  {
    let version = "0.1.0a";

    let args: Vec<String> = env::args().collect();

    let file: String = if args.len() >= 2 {
        match fs::read_to_string(args[1].clone()) {
            Ok(x) => x,
            Err(x) => panic!("{}", format!("clear_browser: Error reading file \"{}\", due to (stderr from system): {}", args[1], x).bold().italic().bright_red()),
        }
    } else {
        println!(
            "{}",
            format!("🪟 clear_browser - {} ", version).blue().on_white()
        );
        println!("{}", "\nUsage: clear_browser <file>.json".bright_purple());
        process::exit(0);
    };

    let parsed: Value = serde_json::from_str(file.as_str()).unwrap();

    let parsed = too_clear(&parsed);

    println!("{:#?}", parsed);
}
