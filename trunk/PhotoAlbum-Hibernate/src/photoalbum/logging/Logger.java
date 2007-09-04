package photoalbum.logging;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Collection;
import java.util.Date;
import java.util.Hashtable;

import photoalbum.common.PhotoAlbumManager;


public class Logger {
	
	public static final String LOGS_DIRECTORY = PhotoAlbumManager.LOGS_DIRECTORY;
	
	public static final String DEFAULT_LOG_FILENAME = PhotoAlbumManager.DEFAULT_LOG_FILENAME;
	
	private static Logger defaultInstance = null;
	
	private static Hashtable<String, Logger> loggers = null;
	
	private String logFileName = Logger.LOGS_DIRECTORY + "/" + Logger.DEFAULT_LOG_FILENAME;
	
	private PrintWriter logWriter = null;
	
	private Logger() {
	}
	
	private Logger(String logFileName) {
		this.setLogFileName(logFileName);
	}

	private static Hashtable<String, Logger> getLoggers() {
		if (loggers == null) {
			loggers = new Hashtable<String, Logger>();
		}
		return loggers;
	}
	
	public static Logger getDefaultInstance() {
		if (Logger.defaultInstance == null) {
			Logger.defaultInstance = new Logger();
			Logger.getLoggers().put(Logger.defaultInstance.getLogFileName(), Logger.defaultInstance);
		}
		return Logger.defaultInstance;
	}
	
	public static Logger getLogger(String logFileName) {
		Logger result = null;
		if (logFileName != null) {
			result = Logger.getLoggers().get(logFileName);
			if (result == null) {
				result = new Logger(logFileName);
				Logger.getLoggers().put(result.getLogFileName(), result);
			}
		}
		return result;
	}
	
	public static void closeAll() {
		Collection<Logger> loggers = Logger.getLoggers().values();
		for (Logger logger : loggers) {
			logger.close();
		}
	}
	
	public String getLogFileName() {
		File file = new File(logFileName);
		File parent = new File(file.getParent());
		if (!parent.exists()) {
			parent.mkdirs();
		}
		return this.logFileName;
	}
	
	private void setLogFileName(String logFileName) {
		if (logFileName != null) {
			if (!PhotoAlbumManager.parentDirExists(logFileName)) {
				PhotoAlbumManager.createParentDirs(logFileName);
			}
			this.logFileName = Logger.LOGS_DIRECTORY + "/" + logFileName;
		} else {
			throw new IllegalArgumentException("[null] is not a valid argument for [void setLogFileName(String)].");
		}
	}
	
	private synchronized PrintWriter getLogWriter() {
		if (this.logWriter == null) {
			try {
				FileWriter fWriter = new FileWriter(this.getLogFileName(), true);
				this.logWriter = new PrintWriter(fWriter);
			} catch (FileNotFoundException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		return this.logWriter;
	}
	
	private synchronized void setLogWriter(PrintWriter logWriter) {
		this.logWriter = logWriter;
	}
	
	public synchronized void log(String msg) {
		Date currentTime = new Date();
		String currentTimeString = PhotoAlbumManager.defaultDateTimeFormat.format(currentTime);
		PrintWriter writer = this.getLogWriter();
		writer.println("*************************************************************************");
		writer.println("[" + currentTimeString + "]");
		writer.println(msg);
		writer.flush();
		writer.close();
		this.setLogWriter(null);
	}
	
	public synchronized void log(Throwable e) {
		this.log(e, "");
	}
	
	private synchronized void log(Throwable e, String indent) {
		Date currentTime = new Date();
		String currentTimeString = PhotoAlbumManager.defaultDateTimeFormat.format(currentTime);
		PrintWriter writer = this.getLogWriter();
		writer.println("*************************************************************************");
		writer.println(indent + "[" + currentTimeString + "] ERROR");
		writer.println(indent + e.getMessage());
		StackTraceElement[] stackTrace = e.getStackTrace();
		for (StackTraceElement stackTraceElement : stackTrace) {
			writer.println(indent + stackTraceElement.toString());
		}
		Throwable cause = e.getCause();
		if (cause != null) {
			writer.println(indent + "Caused by:");
			this.log(cause, indent + "\t");
		}
		writer.close();
		this.setLogWriter(null);
	}
	
	public void close() {
		this.getLogWriter().close();
		Logger.getLoggers().remove(this);
	}
	
}
