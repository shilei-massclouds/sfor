#![no_std]

#[no_mangle]
pub fn libos_puts(_msg: &str) {
}

#[cfg(target_os = "none")]
#[panic_handler]
fn panic(_info: &core::panic::PanicInfo<'_>) -> ! {
    /* Todo: terminate the system */
    loop {}
}
