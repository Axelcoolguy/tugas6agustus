<?php
session_start();
if(!isset($_SESSION['username'])){
    header("location:login.php");
    exit();
}

include 'koneksi.php';
$id = $_GET['id'];

// Ambil info file foto lalu hapus dari folder uploads
$data = mysqli_fetch_array(mysqli_query($koneksi, "SELECT foto FROM barang_bukti WHERE id='$id'"));
if (file_exists("uploads/" . $data['foto'])) {
    unlink("uploads/" . $data['foto']);
}

// Hapus record dari database
mysqli_query($koneksi, "DELETE FROM barang_bukti WHERE id='$id'");
header("Location: index.php");
?>
