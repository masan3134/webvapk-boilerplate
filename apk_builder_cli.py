import typer
from rich.console import Console
from pathlib import Path
import subprocess

app = typer.Typer()
console = Console()

@app.command()
def build():
    console.print("[bold green]✅ APK oluşturma işlemi başlatıldı...[/bold green]")

    # 📁 build klasörü oluştur
    build_dir = Path("build")
    build_dir.mkdir(exist_ok=True)

    # 📄 dummy bir manifest dosyası oluştur
    manifest_file = build_dir / "AndroidManifest.xml"
    manifest_file.write_text("<manifest><application/></manifest>")

    # 📄 dummy bir kod dosyası
    main_file = build_dir / "Main.java"
    main_file.write_text("public class Main { public static void main(String[] args) { System.out.println(\"Hello APK\"); } }")

    # 📦 APK dosyası taklidi (sadece zip uzantılı klasör)
    apk_path = build_dir / "myapp.apk"
    subprocess.run(["zip", "-r", str(apk_path), "."], cwd=build_dir)

    console.print(f"[bold blue]📦 APK dosyası oluşturuldu:[/bold blue] {apk_path.resolve()}")

if __name__ == "__main__":
    app()
