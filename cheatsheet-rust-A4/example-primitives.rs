//-------------------------------------------------------------------
// @copyright 2018 DennyZhang.com
// Licensed under MIT
//   https://www.dennyzhang.com/wp-content/mit_license.txt
//
// Author : Denny <https://www.dennyzhang.com/contact>
// Description :
// https://cheatsheet.dennyzhang.com/cheatsheet-golang-A4
// https://doc.rust-lang.org/stable/rust-by-example/primitives.html
// --
// Created : <2018-04-07>
// Updated: Time-stamp: <2019-07-19 13:43:41>
//-------------------------------------------------------------------
fn main() {
    // Variables can be type annotated.
    let logical: bool = true;

    let a_float: f64 = 1.0;  // Regular annotation
    let an_integer   = 5i32; // Suffix annotation

    // Or a default will be used.
    let default_float   = 3.0; // `f64`
    let default_integer = 7;   // `i32`
    
    // A type can also be inferred from context 
    let mut inferred_type = 12; // Type i64 is inferred from another line
    inferred_type = 4294967296i64;
    
    // A mutable variable's value can be changed.
    let mut mutable = 12; // Mutable `i32`
    mutable = 21;
    println!("mutable={}", mutable)
    
    // Error! The type of a variable can't be changed.
    // mutable = true;
    
    // Variables can be overwritten with shadowing.
    // let mutable = true;
}
