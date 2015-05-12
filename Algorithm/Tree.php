#!/usr/bin/php

<?php

/**
 *常用的比较有趣的算法
 */
class Tree {

	function __construct() {

	}

	//有一母牛，到4岁可生育，每年一头，所生均是一样的母牛，到15岁绝育，不再能生，20岁死亡，问n年后有多少头牛
	private function niunum($n) {

		static $num = 1;
		for ($i = 1; $i <= $n; $i++) {
			if ($i >= 4 && $i < 15) {
				$num++;
				niunum($n - $i);
			}
			if ($i == 20) {
				$num--;
			}

		}
		return $num;
	}

	//合并多个数组，不用array_merge()，思路：遍历每个数组，重新组成一个新数组。

	private function unionArray($a, $b) {

		$re = array();
		foreach ($a as $v) {
			$re[] = $v;
		}

		foreach ($b as $v) {
			$re[] = $v;
		}

		return $re;
	}

	//把数组array(12,34,56,32) 转化为 array(1,2,3,4,5,6,3,2)

	public function changeArr($arr) {

		return str_split(implode('', $arr));
	}

}

print_r(changeArr(array(12, 34, 56, 32)));

print_r(unionArray(array(1, 2, 4, 5, 's'), array(2, 5, 7, 'c', 'd')));

echo niunum(10);

?>