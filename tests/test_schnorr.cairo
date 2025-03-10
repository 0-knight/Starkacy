%builtins output range_check bitwise ec_op poseidon

from starkware.cairo.common.ec_point import EcPoint
from starkware.cairo.common.ec import assert_on_curve, ec_add, ec_double, ec_op
from starkware.cairo.common.cairo_builtins import EcOpBuiltin, BitwiseBuiltin, HashBuiltin, PoseidonBuiltin
from starkware.cairo.common.serialize import serialize_word
from src.math_utils import ec_mul
from src.schnorr import verify_schnorr_signature_bn254
from starkware.cairo.common.hash import hash2

func main{output_ptr: felt*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*, ec_op_ptr: EcOpBuiltin*, poseidon_ptr: PoseidonBuiltin*}() {
    alloc_locals;

    // local alpha_G_x_low: felt;
    // local alpha_G_x_high: felt;
    // local alpha_G_y_low: felt;
    // local alpha_G_y_high: felt;
    // local mod_alpha_G_x: felt;
    // local mod_alpha_G_y: felt;
    // local response_low: felt;
    // local response_high: felt;
    // local public_key_x_low: felt;
    // local public_key_x_high: felt;
    // local public_key_y_low: felt;
    // local public_key_y_high: felt;

    local P_s_x: felt;
    local P_s_y: felt;
    local P_u_x: felt;
    local P_u_y: felt;
    local s: felt;
    local R_x: felt;
    local R_y: felt;
    local i: felt;
    local m: felt;

    // %{
    //     alpha_G_x = program_input['alpha_G_x']
    //     alpha_G_y = program_input['alpha_G_y']
    //     response = program_input['response']
    //     public_key_x = program_input['public_key_x']
    //     public_key_y = program_input['public_key_y']

    //     ids.alpha_G_x = alpha_G_x
    //     ids.alpha_G_y = alpha_G_y
    //     ids.response = response
    //     ids.public_key_x = public_key_x
    //     ids.public_key_y = public_key_y
    // %}

    %{
        import sys, os
        cwd = os.getcwd()
        sys.path.append(cwd)

        from src.schnorrpy import SchnorrSignatureBN254
        
        k_u = 12
        k_s = 2
        schnorr = SchnorrSignatureBN254()
        (P_s, P_u, s, R, i, m) = schnorr.prove(k_u, k_s)
        print("Off-chain proof sent")
        schnorr.verify(P_s, P_u ,s, R, i, m)
        print("Off-chain verification done")
        print("Assertting on-chain verification")
        print("If there is no error, on-chain verification is completed")

        FIELD_PRIME = 3618502788666131213697322783095070105623107215331596699973092056135872020481

        # ids.alpha_G_x_low = alpha.x & ((1<<128) - 1)
        # ids.alpha_G_x_high = alpha.x >> 128
        # ids.alpha_G_y_low = alpha.y & ((1<<128) - 1)
        # ids.alpha_G_y_high = alpha.y >> 128
        # ids.mod_alpha_G_x = (alpha.x % FIELD_PRIME)
        # ids.mod_alpha_G_y = (alpha.y % FIELD_PRIME)
        # ids.response_low = response & ((1<<128) - 1)
        # ids.response_high = response >> 128
        # ids.public_key_x_low = pk.x & ((1<<128) - 1)
        # ids.public_key_x_high = pk.x >> 128
        # ids.public_key_y_low = pk.y & ((1<<128) - 1)
        # ids.public_key_y_high = pk.y >> 128

        ids.P_s_x = P_s.x % FIELD_PRIME
        ids.P_s_y = P_s.y % FIELD_PRIME
        ids.P_u_x = P_u.x % FIELD_PRIME
        ids.P_u_y = P_u.x % FIELD_PRIME
        ids.s = s
        ids.R_x = R.x
        ids.R_y = R.y
        ids.i = i
        ids.m = m

        print(P_u.x, P_u.x % FIELD_PRIME)
        print(P_u.y, P_u.y % FIELD_PRIME)
        print(P_s.x, P_s.x % FIELD_PRIME)
        print(P_s.y, P_s.y % FIELD_PRIME)
        # print(P_u.x >> 128, P_u.x & ((1<<128) - 1))
    %}

    // verify_schnorr_signature_bn254(
    //     alpha_G_x_low,
    //     alpha_G_x_high,
    //     alpha_G_y_low,
    //     alpha_G_y_high,
    //     mod_alpha_G_x,
    //     mod_alpha_G_y,
    //     response_low,
    //     response_high,
    //     public_key_x_low,
    //     public_key_x_high,
    //     public_key_y_low,
    //     public_key_y_high
    // );

    verify_schnorr_signature_bn254(
        P_s_x,
        P_s_y,
        P_u_x,
        P_u_y,
        s,
        R_x,
        R_y,
        i,
        m
    );

    return ();
}