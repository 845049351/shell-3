#!/usr/bin/php

<?php

class Common {

	function __construct() {

	}

	//冒泡排序
	private function bubble_sort($arr) {
	    
		$n = count($arr);

	    for ($i=0;$i<$n-1;$i++){
	    
		    for ($j=$i+1;$j<$n;$j++) {
	    
			     if ($arr[$j]<$arr[$i]) {
	        
			        $temp=$arr[$i];
				    $arr[$i]=$arr[$j];
	                $arr[$j]=$temp;
	            }
	        }
	    }

	    return $arr;
	}


	//二分查找-递归
	function bin_search($arr,$low,$high,$value) {

		if($low>$high){

			return false;

		} else {
		
			$mid=floor(($low+$high)/2);

	        if($value==$arr[$mid]){

	            return $mid;
			}elseif($value<$arr[$mid]){

				return bin_search($arr,$low,$mid-1,$value);
			
			}else{

	            return bin_search($arr,$mid+1,$high,$value);
			}
		}
	}


	//二分查找-非递归

	public function bin_search($arr,$low,$high,$value) {
    
		while($low<=$high) {

            $mid=floor(($low+$high)/2);
        
			if($value==$arr[$mid]){

                return $mid;
			
			}elseif($value<$arr[$mid]){

                $high=$mid-1;

			}else{

                $low=$mid+1;
			}
		}

	    return false;
	}

	//快速排序

	public function quick_sort($arr) {
    
		$n=count($arr);
		if($n<=1)
        
			return $arr;
    
		$key=$arr[0];
    
		$left_arr=array();
    
		$right_arr=array();
    
		for($i=1;$i<$n;$i++) {
        
			if($arr[$i]<=$key){

				$left_arr[]=$arr[$i];

			}else{

                $right_arr[]=$arr[$i];
			}
        }
    $left_arr=quick_sort($left_arr);
    $right_arr=quick_sort($right_arr);
    return array_merge($left_arr,array($key),$right_arr);
}

	//插入排序
	public function insertSort($arr) {
    
		$n=count($arr);

        for($i=1;$i<$n;$i++) {

			$tmp=$arr[$i];
			$j=$i-1;

	        while($arr[$j]>$tmp) {

	            $arr[$j+1]=$arr[$j];
	            $arr[$j]=$tmp;
	            $j--;

	            if($j<0){

	                break;

				}
	        }
        }

        return $arr;
	}

	// 选择排序
	public function select_sort($arr) {

        $n=count($arr);

	    for($i=0;$i<$n;$i++) {

	        $k=$i;
	        for($j=$i+1;$j<$n;$j++) {
		
	           if($arr[$j]<$arr[$k])
	               $k=$j;
	        }

	        if($k!=$i) {

	            $temp=$arr[$i];
	            $arr[$i]=$arr[$k];
	            $arr[$k]=$temp;
	        }
	    }

        return $arr;
	}

}

?>