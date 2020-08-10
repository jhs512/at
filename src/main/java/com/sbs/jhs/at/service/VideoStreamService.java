package com.sbs.jhs.at.service;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Optional;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

@Service
public class VideoStreamService {

	public static final String CONTENT_TYPE = "Content-Type";
	public static final String CONTENT_LENGTH = "Content-Length";
	public static final String VIDEO_CONTENT = "video/";
	public static final String CONTENT_RANGE = "Content-Range";
	public static final String ACCEPT_RANGES = "Accept-Ranges";
	public static final String BYTES = "bytes";
	public static final int BYTE_RANGE = 1024;

	/**
	 * Prepare the content.
	 *
	 * @param fileName String.
	 * @param fileType String.
	 * @param range    String.
	 * @return ResponseEntity.
	 */
	public ResponseEntity<byte[]> prepareContent(ByteArrayInputStream is, int fileSize, String fileType, String range) {
		long rangeStart = 0;
		long rangeEnd;
		byte[] data;

		try {
			if (range == null) {
				return ResponseEntity.status(HttpStatus.OK).header(CONTENT_TYPE, VIDEO_CONTENT + fileType)
						.header(CONTENT_LENGTH, String.valueOf(fileSize))
						.body(readByteRange(is, rangeStart, fileSize - 1)); // Read the object and convert it
																			// as bytes
			}
			String[] ranges = range.split("-");
			rangeStart = Long.parseLong(ranges[0].substring(6));
			if (ranges.length > 1) {
				rangeEnd = Long.parseLong(ranges[1]);
			} else {
				rangeEnd = fileSize - 1;
			}
			if (fileSize < rangeEnd) {
				rangeEnd = fileSize - 1;
			}
			data = readByteRange(is, rangeStart, rangeEnd);
		} catch (IOException e) {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
		}
		String contentLength = String.valueOf((rangeEnd - rangeStart) + 1);
		return ResponseEntity.status(HttpStatus.PARTIAL_CONTENT).header(CONTENT_TYPE, VIDEO_CONTENT + fileType)
				.header(ACCEPT_RANGES, BYTES).header(CONTENT_LENGTH, contentLength)
				.header(CONTENT_RANGE, BYTES + " " + rangeStart + "-" + rangeEnd + "/" + fileSize).body(data);

	}

	public byte[] readByteRange(InputStream inputStream, long start, long end) throws IOException {
		try (ByteArrayOutputStream bufferedOutputStream = new ByteArrayOutputStream()) {
			byte[] data = new byte[BYTE_RANGE];
			int nRead;
			while ((nRead = inputStream.read(data, 0, data.length)) != -1) {
				bufferedOutputStream.write(data, 0, nRead);
			}
			bufferedOutputStream.flush();
			byte[] result = new byte[(int) (end - start) + 1];
			System.arraycopy(bufferedOutputStream.toByteArray(), (int) start, result, 0, result.length);
			return result;
		}
	}
}
