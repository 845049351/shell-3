#!/usr/bin/php

<?php

include 'Common.php';
/**
 *
 */
class Uses extends Common {

	private static $arr = array(3, 5, 1, 4, 2);

	public static function UseBubbleSort() {

		$s = parent::bubble_sort(self::$arr);
		print_r($s);
	}

	public static function UseBinSeaech() {

		$bin_search = parent::bin_search(self::$arr, 2, 5, 3);
		print_r($bin_search);
	}

	public static function UseBinSearchNo() {

		$value = parent::bin_search_no(self::$arr, 2, 5, 3);
		print_r($value);
	}

	public function UseInsertSort() {

		$value = parent::insertSort(self::$arr, 2, 5, 3);
		print_r($value);
	}

	public static function UseQuickSort() {

		$v = parent::quick_sort(self::$arr);
		print_r($v);

	}

	public function UseSelectSort() {

		$v = parent::select_sort(self::$arr);
		print_r($v);
	}

}

// Uses::UseBubbleSort();
echo "－－－－－－－－－－－－\n";
Uses::UseBinSeaech();
echo "－－－－－－－－－－－－\n";
// Uses::UseBinSearchNo();
echo "－－－－－－－－－－－－\n";
// Uses::UseQuickSort();
echo "－－－－－－－－－－－－\n";
// Uses::UseSelectSort();

// Uses::UseInsertSort();

?>