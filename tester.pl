#!/usr/bin/perl

use strict;
use warnings;

my $spec = <<END_OF_SPEC;
設定ファイル仕様

ラベルとデータ、データとデータはタブ区切りとする。
#で始まる行はコメントで、無視される。

name	名前
	テストの名前を指定する。

main_command	コマンド
	変換器を実行するコマンドを指定する。

main_expected_return	値
	変換器の実行後戻る値を指定する。
	指定しない場合は0を期待する。

main_expected_stderr	ファイル
	変換器の標準エラー出力として期待する値を指定する。
	指定しない場合は何もないことを期待する。

build_command	コマンド
	変換したプログラムをビルドするコマンドを指定する。
	指定しない場合はビルドをしない。

run_command	コマンド
	ビルドしたプログラムを実行するコマンドを指定する。
	指定しない場合は実行をしない。

run_test	入力ファイル	出力ファイル
	ビルドしたプログラムを実行してテストする。複数指定できる。

END_OF_SPEC

if (@ARGV < 1) {
	die "config file name not specified\n";
}

open(CONFIG, "< $ARGV[0]") or die("config file open error\n");

my $test_name = "(no name)";
my $main_command;
my $main_expected_return = 0;
my $main_expected_stderr_file;
my $build_command;
my $run_command;
my @run_test = ();

while (my $line = <CONFIG>) {
	chomp($line);
	if ($line =~ /\A#/ || $line eq "") { next; }
	my @data = split(/\t/, $line);
	if ($data[0] eq "name") {
		if (@data < 1) { die "parameter absent for name\n"; }
		$test_name = $data[1];
	} elsif ($data[0] eq "main_command") {
		if (@data < 1) { die "parameter absent for main_command\n"; }
		$main_command = $data[1];
	} elsif ($data[0] eq "main_expected_return") {
		if (@data < 1) { die "parameter absent for main_expected_return\n"; }
		if ($data[1] !~ /\A\d+\z/) { die "invalid parameter for main_expected_return\n"; }
		$main_expected_return = int($data[1]);
	} elsif ($data[0] eq "main_expected_stderr") {
		if (@data < 1) { die "parameter absent for main_expected_stderr\n"; }
		$main_expected_stderr_file = $data[1];
	} elsif ($data[0] eq "build_command") {
		if (@data < 1) { die "parameter absent for build_command\n"; }
		$build_command = $data[1];
	} elsif ($data[0] eq "run_command") {
		if (@data < 1) { die "parameter absent for run_command\n"; }
		$run_command = $data[1];
	} elsif ($data[0] eq "run_test") {
		if (@data < 2) { die "parameter absent for run_test\n"; }
		push(@run_test, $data[1]);
		push(@run_test, $data[2]);
	} else {
		die "unknown data: " . $data[0] . "\n";
	}
}
close(CONFIG);

print "start test $test_name\n";
print "run $main_command\n";
open(ERR, "$main_command 2>&1 |") or die("execution failed\n");
my $main_err = "";
while (<ERR>) { $main_err .= $_; }
close(ERR);

my $main_expected_err = "";
if (defined($main_expected_stderr_file)) {
	open(EERR, "< $main_expected_stderr_file") or die("expected stderr file open failed\n");
	while (<EERR>) { $main_expected_err .= $_; }
	close(EERR);
}

my $main_return = $? >> 8;
if ($main_return != $main_expected_return) {
	print "FAILED: main return value mismatch\n";
	print "expected: $main_expected_return\n";
	print "actual: $main_return\n";
	exit 1;
}

if ($main_err ne $main_expected_err) {
	print "FAILED : main stderr mismatch\n";
	print "expected:\n$main_expected_err\n";
	print "actual:\n$main_err\n";
	exit 1;
}

print "PASSED\n";
