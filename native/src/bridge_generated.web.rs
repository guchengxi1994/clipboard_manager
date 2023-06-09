use super::*;
// Section: wire functions

#[wasm_bindgen]
pub fn wire_rust_bridge_say_hello(port_: MessagePort) {
    wire_rust_bridge_say_hello_impl(port_)
}

#[wasm_bindgen]
pub fn wire_set_db_path(port_: MessagePort, s: String) {
    wire_set_db_path_impl(port_, s)
}

#[wasm_bindgen]
pub fn wire_init_db(port_: MessagePort) {
    wire_init_db_impl(port_)
}

#[wasm_bindgen]
pub fn wire_init_folder(port_: MessagePort, s: String) {
    wire_init_folder_impl(port_, s)
}

#[wasm_bindgen]
pub fn wire_set_locale_path(port_: MessagePort, s: String) {
    wire_set_locale_path_impl(port_, s)
}

#[wasm_bindgen]
pub fn wire_get_locale(port_: MessagePort) {
    wire_get_locale_impl(port_)
}

#[wasm_bindgen]
pub fn wire_set_locale(port_: MessagePort, s: String) {
    wire_set_locale_impl(port_, s)
}

#[wasm_bindgen]
pub fn wire_set_watermark_path(port_: MessagePort, s: String) {
    wire_set_watermark_path_impl(port_, s)
}

#[wasm_bindgen]
pub fn wire_get_watermark(port_: MessagePort) {
    wire_get_watermark_impl(port_)
}

#[wasm_bindgen]
pub fn wire_set_watermark(port_: MessagePort, s: String) {
    wire_set_watermark_impl(port_, s)
}

// Section: allocate functions

// Section: related functions

// Section: impl Wire2Api

impl Wire2Api<String> for String {
    fn wire2api(self) -> String {
        self
    }
}

impl Wire2Api<Vec<u8>> for Box<[u8]> {
    fn wire2api(self) -> Vec<u8> {
        self.into_vec()
    }
}
// Section: impl Wire2Api for JsValue

impl Wire2Api<String> for JsValue {
    fn wire2api(self) -> String {
        self.as_string().expect("non-UTF-8 string, or not a string")
    }
}
impl Wire2Api<u8> for JsValue {
    fn wire2api(self) -> u8 {
        self.unchecked_into_f64() as _
    }
}
impl Wire2Api<Vec<u8>> for JsValue {
    fn wire2api(self) -> Vec<u8> {
        self.unchecked_into::<js_sys::Uint8Array>().to_vec().into()
    }
}
