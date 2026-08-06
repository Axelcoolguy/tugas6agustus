<?php
include "koneksi.php";
?>
<!DOCTYPE html>
<html>
<head>
    <title>Daftar File</title>
    <link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>

<div class="container">
    <h2>Daftar File</h2>

    <a href="form_upload.php" class="btn-add">+ Upload File Baru</a>

    <table class="data-table">
        <thead>
            <tr>
                <th>No</th>
                <th>Judul File</th>
                <th>Tanggal</th>
                <th>Jenis File</th>
                <th>Ukuran</th>
                <th>Aksi</th>
            </tr>
        </thead>
        <tbody>
            <?php
            $no = 1;
            $tampil = mysqli_query($koneksi, "SELECT * FROM t_file ORDER BY id_file DESC");
            while ($data = mysqli_fetch_array($tampil)) {
                $ukuran_kb = round($data['ukuran_file'] / 1024, 2) . " KB";
                $tanggal = date('d/m/Y', strtotime($data['tanggal_upload']));
            ?>
            <tr>
                <td><?= $no++; ?></td>
                <td><?= htmlspecialchars($data['judul_file']); ?></td>
                <td><?= $tanggal; ?></td>
                <td><?= htmlspecialchars($data['jenis_file']); ?></td>
                <td><?= $ukuran_kb; ?></td>
                <td>
                    <a href="download.php?id_file=<?= $data['id_file']; ?>" class="btn-action btn-download">Download</a>
                    <a href="delete.php?id_file=<?= $data['id_file']; ?>" class="btn-action btn-delete" onclick="return confirm('Yakin ingin menghapus file ini?')">Delete</a>
                </td>
            </tr>
            <?php } ?>
        </tbody>
    </table>
</div>

</body>
</html>