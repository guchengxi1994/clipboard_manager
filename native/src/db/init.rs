use lazy_static::lazy_static;
use std::{fs::File, path::Path, sync::Mutex};
use tokio::runtime::Runtime;

use super::connection::{MyPool, POOL};

lazy_static! {
    pub static ref DB_PATH: Mutex<String> = Mutex::new(String::new());
}

pub fn path_exists(p: String) -> bool {
    Path::new(&p).exists()
}

const CREATE_CLIPBOARD_CONTENT_DB: &str = "CREATE TABLE IF NOT EXISTS clipboard (
    uuid TEXT NOT NULL PRIMARY KEY ,
    content TEXT,
    type TEXT,
    remark TEXT,
    create_at integer
)";

pub fn init_when_first_time_start() -> anyhow::Result<()> {
    let rt = Runtime::new().unwrap();
    rt.block_on(async {
        let db_path = (*DB_PATH.lock().unwrap()).clone();
        // let url = format!("sqlite:{:?}",db_path.as_str());
        let url = String::from("sqlite:") + &db_path;
        println!("{:?}", url);

        if path_exists(db_path.clone()) {
            let pool = POOL.clone();
            let mut pool = pool.write().await;
            *pool = MyPool::new(&url).await;
            return anyhow::Ok(());
        }
        let _ = File::create(db_path)?;
        let pool = POOL.clone();
        let mut pool = pool.write().await;
        *pool = MyPool::new(&url).await;
        let _p = pool.get_pool();
        let _ = sqlx::query(CREATE_CLIPBOARD_CONTENT_DB).execute(_p).await?;

        anyhow::Ok(())
    })
}
