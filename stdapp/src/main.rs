#![no_std]
#![no_main]

extern "Rust" {
    fn libos_puts(msg: &str);
}

#[allow(dead_code)]
fn main() {
    unsafe {
        libos_puts("Hello, LibOS!\n");
    }
}

/// Entry point of panics from the core crate (`panic_impl` lang item).
#[cfg(not(test))]
#[panic_handler]
pub fn begin_panic_handler(_info: &core::panic::PanicInfo<'_>) -> ! {
    loop {}
}
