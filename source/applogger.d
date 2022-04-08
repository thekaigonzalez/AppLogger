module source.applogger;

import std.stdio;
import std.net.curl;
import colorize;
import std.file: read, exists, mkdir;
import std.string;
import std.process;
import std.zip;
import std.json;
import std.conv;
import std.algorithm;
import std.array;

void print_usage(char err='n', string msg="") {
	writeln("usage: nfy-get <NFy|NFyJS|NFyMono|LibNFy>");
	if (err=='-') write ("error: " ~ msg);
	
}

void logMessage(string msg) {
	writeln(("-> " ~ msg).color("blue"));
}

void errorMessage(string msg) {
	writeln(("! " ~ msg).color("red"));
}

void successMessage(string msg) {
	writeln(("> " ~ msg).color("green"));
}

void postMSG(string msg) {
	writeln(("* " ~ msg).color("light_white"));
}

void HintMSG(string msg) {
	writeln(("* " ~ msg).color("yellow"));
}

void DownloadFile(string url, string f) {
	download(url, f);
}

void Extract(string fname, string outputdir) {
	logMessage("Extracting " ~ fname ~ "...");
	auto zip = new ZipArchive(read(fname));
	foreach (ArchiveMember am; zip.directory)
		{
			try {
				// exclude system dirs
			if (startsWith(am.name, "playlists")) continue;
			if (startsWith(am.name, "songs")) continue;
			if (startsWith(am.name, "docs")) continue;
			if (startsWith(am.name, "Linux")) continue;
			
			zip.expand(am);
			logMessage("EXTRACT - " ~ am.name);
			
			auto data = cast(string)am.expandedData();
			File d = File(outputdir ~ "/" ~ am.name, "wb");
			d.write(data);
			d.close();
			} catch (Exception e) {
				errorMessage("Failed to extract " ~ am.name);
			}
		}
}

void MakeIfnot(string dir) {
	if (!exists(dir)) {
			mkdir(dir);
		}
}
