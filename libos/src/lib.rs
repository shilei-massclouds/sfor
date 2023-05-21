#![no_std]
#![feature(asm_const)]

mod boot;

#[no_mangle]
pub fn libos_puts(_msg: &str) {
}

unsafe extern "C" fn rust_entry(_magic: usize, _mbi: usize) {
}

#[cfg(target_os = "none")]
#[panic_handler]
fn panic(_info: &core::panic::PanicInfo<'_>) -> ! {
    /* Todo: terminate the system */
    loop {}
}
