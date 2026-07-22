from __future__ import annotations

import hashlib
import json
import tempfile
import unittest
import zipfile
from pathlib import Path
from unittest import mock

from scripts import mod_packages


class ModPackagesTest(unittest.TestCase):
    def setUp(self) -> None:
        self.temp_dir = tempfile.TemporaryDirectory()
        self.repo_root = Path(self.temp_dir.name)
        mods_root = self.repo_root / "mods"
        mods_root.mkdir()
        (mods_root / "pyproject.toml").write_text(
            '[project]\nname = "fixture"\nversion = "1.2.3"\n',
            encoding="utf-8",
        )

    def tearDown(self) -> None:
        self.temp_dir.cleanup()

    def _mod_dir(self) -> Path:
        mod_dir = self.repo_root / "mods" / "Mods" / "UserCode" / "SampleMod"
        mod_dir.mkdir(parents=True)
        return mod_dir

    def test_package_mod_creates_deterministic_install_archive(self) -> None:
        mod_dir = self._mod_dir()
        (mod_dir / "Sample.cs").write_text("public class Sample {}\n", encoding="utf-8")
        assets = mod_dir / "Assets"
        assets.mkdir()
        (assets / "Sample.unity3d").write_bytes(b"materialized unity bundle")
        output = self.repo_root / "packages"

        mod_packages.package_mod(
            self.repo_root, output, "SampleMod", "sample-mod", "abc123"
        )
        archive = output / "SampleMod-1.2.3.zip"
        first_digest = hashlib.sha256(archive.read_bytes()).hexdigest()

        mod_packages.package_mod(
            self.repo_root, output, "SampleMod", "sample-mod", "abc123"
        )

        self.assertEqual(hashlib.sha256(archive.read_bytes()).hexdigest(), first_digest)
        with zipfile.ZipFile(archive) as package:
            self.assertEqual(
                package.namelist(),
                [
                    "Mods/UserCode/SampleMod/Assets/Sample.unity3d",
                    "Mods/UserCode/SampleMod/Sample.cs",
                ],
            )
        manifest = json.loads((output / "manifest.json").read_text(encoding="utf-8"))
        record = manifest["packages"][0]
        self.assertEqual(record["package_name"], "sample-mod")
        self.assertEqual(record["registry_version"], "1.2.3+abc123")
        self.assertEqual(
            record["lfs_assets"],
            ["mods/Mods/UserCode/SampleMod/Assets/Sample.unity3d"],
        )

    def test_package_mod_rejects_unmaterialized_lfs_pointer(self) -> None:
        mod_dir = self._mod_dir()
        (mod_dir / "Sample.unity3d").write_text(
            "version https://git-lfs.github.com/spec/v1\n"
            "oid sha256:0123456789abcdef\n"
            "size 1234\n",
            encoding="utf-8",
        )

        with self.assertRaisesRegex(ValueError, "Git LFS object is not materialized"):
            mod_packages.package_mod(
                self.repo_root,
                self.repo_root / "packages",
                "SampleMod",
                "sample-mod",
                "abc123",
            )

    def test_publish_mod_uploads_archive_metadata_and_checksum(self) -> None:
        package_dir = self.repo_root / "packages"
        package_dir.mkdir()
        record = {
            "archive": "SampleMod-1.2.3.zip",
            "metadata": "SampleMod-1.2.3.json",
            "checksum_file": "SampleMod-1.2.3.zip.sha256",
            "package_name": "sample-mod",
            "registry_version": "1.2.3+abc123",
        }
        for field in ("archive", "metadata", "checksum_file"):
            (package_dir / record[field]).write_bytes(field.encode())
        (package_dir / "manifest.json").write_text(
            json.dumps({"schema": 1, "packages": [record]}), encoding="utf-8"
        )
        uploads: list[str] = []

        with mock.patch.object(
            mod_packages,
            "_upload_idempotently",
            side_effect=lambda _path, url, _authorization: uploads.append(url),
        ):
            mod_packages.publish_mod(
                package_dir,
                "https://forgejo.example",
                "coilyco-gaming",
                "coilyco-ops",
                "token",
            )

        self.assertEqual(len(uploads), 3)
        self.assertTrue(all("/sample-mod/1.2.3%2Babc123/" in url for url in uploads))


if __name__ == "__main__":
    unittest.main()
