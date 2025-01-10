import java.io.*;
import java.nio.file.*;
import java.util.List;
import org.apache.maven.model.*;
import org.apache.maven.model.io.xpp3.*;

// Define method to move files and copy dependencies and plugins
void moveFilesAndDependencies(String sourceModule, String destinationModule) throws IOException {
    File sourceDir = new File(sourceModule);
    File destDir = new File(destinationModule);

    // Check if source and destination directories exist
    if (!sourceDir.exists() || !destDir.exists()) {
        System.err.println("Error: Source or destination module does not exist.");
        return;
    }

    // Move files from source to destination
    File sourceSrcDir = new File(sourceDir, "src");
    if (sourceSrcDir.exists()) {
        File destSrcDir = new File(destDir, "src");
        Files.createDirectories(destSrcDir.toPath());
        for (File file : sourceSrcDir.listFiles()) {
            Files.copy(file.toPath(), new File(destSrcDir, file.getName()).toPath());
        }

        // Remove the original source src directory
        Files.walk(sourceSrcDir.toPath())
                .sorted((a, b) -> b.compareTo(a)) // reverse order to delete subdirectories first
                .forEach(path -> path.toFile().delete());
    } else {
        System.err.println("Warning: 'src' directory not found in source module, skipping file copy.");
    }

    // Copy dependencies and plugins from pom.xml
    File sourcePom = new File(sourceDir, "pom.xml");
    File destinationPom = new File(destDir, "pom.xml");

    if (sourcePom.exists() && destinationPom.exists()) {
        copyDependenciesAndPlugins(sourcePom, destinationPom);
    } else {
        System.err.println("Error: 'pom.xml' not found in source or destination module.");
    }
}

// Define method to copy dependencies and plugins from one pom.xml to another
void copyDependenciesAndPlugins(File sourcePom, File destinationPom) throws IOException {
    MavenXpp3Reader reader = new MavenXpp3Reader();
    MavenXpp3Writer writer = new MavenXpp3Writer();

    try (FileReader sourceReader = new FileReader(sourcePom)) {
        Model sourceModel = reader.read(sourceReader);
        List<Dependency> dependencies = sourceModel.getDependencies();
        List<Plugin> plugins = sourceModel.getBuild() != null ? sourceModel.getBuild().getPlugins() : null;

        // Read destination pom.xml
        try (FileReader destinationReader = new FileReader(destinationPom)) {
            Model destinationModel = reader.read(destinationReader);

            // Copy dependencies
            destinationModel.getDependencies().addAll(dependencies);

            // Copy plugins if available
            if (plugins != null) {
                if (destinationModel.getBuild() == null) {
                    destinationModel.setBuild(new Build());
                }
                destinationModel.getBuild().getPlugins().addAll(plugins);
            }

            // Write back to the destination pom.xml
            try (FileWriter writerDestination = new FileWriter(destinationPom)) {
                writer.write(writerDestination, destinationModel);
                System.out.println("Dependencies and plugins copied from " + sourcePom + " to " + destinationPom);
            }
        }
    }
}

// Method to read modules.txt and process each line
void processModulesFile(String filePath) throws IOException {
    BufferedReader reader = new BufferedReader(new FileReader(filePath));
    String line;

    while ((line = reader.readLine()) != null) {
        line = line.trim();
        // Skip empty lines
        if (line.isEmpty()) {
            continue;
        }

        // Split line into source and destination using '='
        String[] parts = line.split("=");
        if (parts.length == 2) {
            String sourceModule = parts[0].trim();
            String destinationModule = parts[1].trim();
            System.out.println("Processing: Source Module [" + sourceModule + "], Destination Module [" + destinationModule + "]");

            // Call the method to move files and dependencies
            moveFilesAndDependencies(sourceModule, destinationModule);
        } else {
            System.err.println("Invalid line format: " + line);
        }
    }

    reader.close();
}

// Call the method with the path to your modules.txt file
processModulesFile("modules.txt");
