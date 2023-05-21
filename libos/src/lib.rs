#![no_std]
#![feature(asm_const)]

mod boot;
mod uart16550;

/// Console input and output.
pub mod console {
    pub use super::uart16550::*;

    /// Write a slice of bytes to the console.
    pub fn write_bytes(bytes: &[u8]) {
        for c in bytes {
            putchar(*c);
        }
    }
}

unsafe extern "C" fn rust_entry(magic: usize, _mbi: usize) {
    // TODO: handle multiboot info
    if magic == self::boot::MULTIBOOT_BOOTLOADER_MAGIC {
        clear_bss();
        //crate::cpu::init_primary(current_cpu_id());
        self::uart16550::init();
        libos_puts("early console enabled!\n");
        //self::dtables::init_primary();
        //self::time::init_early();
        //rust_main(current_cpu_id(), 0);
    }
}

/// Fills the `.bss` section with zeros.
#[allow(dead_code)]
fn clear_bss() {
    unsafe {
        core::slice::from_raw_parts_mut(sbss as usize as *mut u8,
                                        ebss as usize - sbss as usize)
            .fill(0);
    }
}

#[no_mangle]
pub fn libos_puts(msg: &str) {
    console::write_bytes(msg.as_bytes());
}

#[cfg(target_os = "none")]
#[panic_handler]
fn panic(_info: &core::panic::PanicInfo<'_>) -> ! {
    /* Todo: terminate the system */
    loop {}
}

extern "C" {
    fn stext();
    fn etext();
    fn srodata();
    fn erodata();
    fn sdata();
    fn edata();
    fn sbss();
    fn ebss();
    fn boot_stack();
    fn boot_stack_top();
    fn percpu_start();
    fn percpu_end();
}
