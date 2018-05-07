<?php
if ($argv[1] == 'verify') {
  echo password_verify($argv[2], $argv[3]) ? "true" : "false";
} else if ($argv[1] == 'hash') {
  echo password_hash($argv[2], PASSWORD_DEFAULT);
}