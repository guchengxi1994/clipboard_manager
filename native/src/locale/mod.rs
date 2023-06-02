use lazy_static::lazy_static;
use std::fs::OpenOptions;
use std::io::{Read, Write};
use std::sync::Mutex;

lazy_static! {
    pub static ref LOCALE_PATH: Mutex<String> = Mutex::new(String::new());
}

pub fn init_locale_path(s: String) {
    if !crate::db::init::path_exists(s.clone()) {
        let _ = std::fs::File::create(s.clone());
        let _ = std::fs::write(s.clone(), b"zh");
    }
    let mut _s = LOCALE_PATH.lock().unwrap();
    *_s = s;
}

pub fn get_locale() -> String {
    let _s = LOCALE_PATH.lock().unwrap();
    let mut file = std::fs::File::open((*_s).clone()).unwrap();
    let mut contents = String::new();
    file.read_to_string(&mut contents).unwrap();
    return contents;
}

pub fn set_locale(locale:String) {
    let _s = LOCALE_PATH.lock().unwrap();
    let mut file = OpenOptions::new().write(true).open((*_s).clone()).unwrap();
    file.write_all(locale.as_bytes()).unwrap();
}
