use lazy_static::lazy_static;
use std::fs::OpenOptions;
use std::io::{Read, Write};
use std::sync::Mutex;

lazy_static! {
    pub static ref WATERMARK_PATH: Mutex<String> = Mutex::new(String::new());
}

pub fn init_watermark_path(s: String) {
    if !crate::db::init::path_exists(s.clone()) {
        let _ = std::fs::File::create(s.clone());
        let _ = std::fs::write(s.clone(), b"xiaoshuyui");
    }
    let mut _s = WATERMARK_PATH.lock().unwrap();
    *_s = s;
}

pub fn get_watermark() -> String {
    let _s = WATERMARK_PATH.lock().unwrap();
    let mut file = std::fs::File::open((*_s).clone()).unwrap();
    let mut contents = String::new();
    file.read_to_string(&mut contents).unwrap();
    return contents;
}

pub fn set_watermark(locale:String) {
    let _s = WATERMARK_PATH.lock().unwrap();
    let mut file = OpenOptions::new().write(true).open((*_s).clone()).unwrap();
    file.write_all(locale.as_bytes()).unwrap();
}