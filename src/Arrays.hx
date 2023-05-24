package tools;

class Arrays {
	public static function merge<T>(array1 : Array<T>, array2 : Array<T>) {
		for (a in array2) array1.push(a);
	}
}
