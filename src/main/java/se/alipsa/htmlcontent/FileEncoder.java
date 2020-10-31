package se.alipsa.htmlcontent;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Base64;

public class FileEncoder {

  public static String contentAsBase64(String fullFileName) throws IOException {
    byte[] content = Files.readAllBytes(Paths.get(fullFileName));
    return "data:image/png;base64, " + Base64.getEncoder().encodeToString(content);
  }
}
