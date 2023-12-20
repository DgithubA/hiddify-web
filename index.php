<?php

$JSON_RESPONSE = false;

$configs = 'vless://';

if($_SERVER['REQUEST_URI'] !== '/sub/'){
    if($JSON_RESPONSE){
        $data = ['ok'=>'false','data'=>[]];
        header('Content-Type: application/json; charset=utf-8');
        echo json_encode($data);
    }
}else echo $configs;
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>maked by Da</title>
</head>
<body>
    Maked by <a href="https://github.com/DgithubA/hiddify-web/">D.a</a>
</body>
</html>