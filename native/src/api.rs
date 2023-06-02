use crate::db::init::DB_PATH;

pub fn rust_bridge_say_hello() -> String {
    String::from("hello from rust")
}

// 设置 db 路径
pub fn set_db_path(s: String) {
    let mut _s = DB_PATH.lock().unwrap();
    *_s = s;
}

pub fn init_db() {
    let m = crate::db::init::init_when_first_time_start();
    match m {
        Ok(_) => {
            println!("初始化数据库成功")
        }
        Err(e) => {
            println!("[rust-init-db-err] : {:?}", e);
            println!("初始化数据库失败")
        }
    }
}

// init path
pub fn init_folder(s: String) {
    if !crate::db::init::path_exists(s.clone()) {
        let _ = std::fs::create_dir(s.clone());
    }
}

// 设置locale路径
pub fn set_locale_path(s: String) {
    crate::locale::init_locale_path(s)
}

// 获取locale
pub fn get_locale() -> String {
    crate::locale::get_locale()
}

// 设置locale
pub fn set_locale(s: String) {
    crate::locale::set_locale(s)
}

// 设置watermark路径
pub fn set_watermark_path(s: String) {
    crate::watermark::init_watermark_path(s)
}

// 获取watermark
pub fn get_watermark() -> String {
    crate::watermark::get_watermark()
}

// 设置watermark
pub fn set_watermark(s: String) {
    crate::watermark::set_watermark(s)
}
