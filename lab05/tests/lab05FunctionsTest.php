<?php
require_once __DIR__ . '/../src/lab05Functions.php';

use PHPUnit\Framework\TestCase;

class lab05FunctionsTest extends TestCase
#
{

    public function test_summarize_text_file_basic(): void {
        $path = __DIR__ . '/data/sample.txt';
        $result = summarize_text_file($path);

        $this->assertIsArray($result);
        $this->assertArrayHasKey('hello', $result);
        $this->assertArrayHasKey('world', $result);
        $this->assertArrayHasKey('again', $result);

        $this->assertEquals(2, $result['hello']);
        $this->assertEquals(2, $result['world']);
        $this->assertEquals(1, $result['again']);
    }

      public function test_multiplication_table_small(): void {
        $t = make_multiplication_table(4);

        $this->assertIsArray($t);
        $this->assertCount(4, $t);
        $this->assertCount(4, $t[0]);

        $this->assertEquals(0, $t[0][0]);
        $this->assertEquals(6, $t[2][3]);   // 2*3
        $this->assertEquals(9, $t[3][3]);   // 3*3
    }

    public function test_pad_to_longest_left_and_right(): void {
        $arr = ["a", "bb", "ccc"];
        pad_to_longest($arr); // left by default
        $this->assertEquals(["  a", " bb", "ccc"], $arr);

        $arr2 = ["a", "bb", "ccc"];
        pad_to_longest($arr2, false); // right
        $this->assertEquals(["a  ", "bb ", "ccc"], $arr2);
    }
}
