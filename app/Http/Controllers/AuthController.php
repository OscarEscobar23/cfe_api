<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Validation\ValidationException;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;
use Symfony\Component\HttpFoundation\Response;

class AuthController extends Controller
{
    public function register(Request $request)
    {
        return User::create([
            'name' => $request->input('name'),
            'rpe' =>$request->input('rpe'),
            'password' =>Hash::make($request->input('password'))
        ]);
    }

    public function login(Request $request)
    {
       if (!Auth::attempt ($request -> only('rpe','password'))){
            return response([
               'messege' => 'Invalid credentials'
            ], Response::HTTP_UNAUTHORIZED);
       }
        $user = Auth::user();

        $token = $user->createToken('token')->plainTextToken;

        $cookie = cookie('jtw',$token, 60 *24); // 1 day

       return response([
           'messege' => 'success'
       ])->withCookie($cookie);
    }

    public function user(){

        return Auth::user();
    }
}
