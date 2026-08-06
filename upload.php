<?php
include "koneksi.php";

if (isset($_POST['simpan'])) {
    $judul_file     = $_POST['judul_file'];
    $tanggal_upload = date('Y-m-d');

    $nama_file  = $_FILES['file']['name'];
    $ukuran_file = $_FILES['file']['size'];
    $jenis_file  = $_FILES['file']['type'];
    $tmp_file    = $_FILES['file']['tmp_name'];

    $folder = "file/";

    if (!is_dir($folder)) {
        mkdir($folder, 0777, true);
    }

    if (move_uploaded_file($tmp_file, $folder . $nama_file)) {
        $simpan = mysqli_query($koneksi, "INSERT INTO t_file (judul_file, tanggal_upload, jenis_file, ukuran_file, nama_file) 
                VALUES ('$judul_file', '$tanggal_upload', '$jenis_file', '$ukuran_file', '$nama_file')");

        if ($simpan) {
            header("location:index.php");
        } else {
            echo "Gagal menyimpan data ke database!";
        }
    } else {
        echo "Gagal mengupload file!";
    }
}
?>