<!DOCTYPE html>
<html>
<head>
    <title>Form Upload File</title>
    <link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>

<div class="container" style="max-width: 500px;">
    <h2>Form Upload File</h2>
    <hr>

    <form action="upload.php" method="POST" enctype="multipart/form-data">
        <div class="form-group">
            <label>Judul File</label>
            <input type="text" name="judul_file" required placeholder="Masukkan judul file...">
        </div>

        <div class="form-group">
            <label>Pilih File</label>
            <input type="file" name="file" required>
        </div>

        <div class="form-actions">
            <a href="index.php" class="btn-back">← Kembali</a>
            <div>
                <input type="reset" value="Reset" class="btn-reset">
                <input type="submit" name="simpan" value="Simpan" class="btn-submit">
            </div>
        </div>
    </form>
</div>

</body>
</html>