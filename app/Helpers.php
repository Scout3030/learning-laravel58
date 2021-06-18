<?php
namespace App;

class Helpers {
	public static function uploadFile($key, $path) {
		request()->file($key)->store($path);
		return request()->file($key)->hashName();
	}
}