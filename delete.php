<?php
session_start();
if(!isset($_SESSION['username'])){
    header("location:login.php");
    exit();
}

include 'koneksi.php';
$id = $_GET['id'];

$data = mysqli_fetch_array(mysqli_query($koneksi, "SELECT foto FROM barang_bukti WHERE id='$id'"));
if (file_exists("uploads/" . $data['foto'])) {
    unlink("uploads/" . $data['foto']);
}

mysqli_query($koneksi, "DELETE FROM barang_bukti WHERE id='$id'");
header("Location: index.php");
?>
