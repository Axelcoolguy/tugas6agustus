<?php
include"koneksi.php";

$tampil=mysqli_query($koneksi,"SELECT * FROM t_file WHERE id_file='$_GET[id_file]'");
$data=mysqli_fetch_array($tampil);

$hapus=mysqli_query($koneksi,"DELETE FROM t_file WHERE id_file='$_GET[id_file]'");

if($hapus){
    if(file_exists("file/$data[nama_file]")){
        unlink("file/$data[nama_file]");
    }
    header("location:index.php");
}else{
    echo"Gagal menghapus";
}
?>