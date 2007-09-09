package photoalbum.network;

import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;

import photoalbum.CreateUserException;
import photoalbum.entities.Category;
import photoalbum.entities.User;

public class NetworkConnection {
	
	public static final String PROPERTY_CMD = "cmd";
	
	public static final String CMD_GET_ALL_USERS = "getAllUsers";
	
	public static final String CMD_ADD_USER = "addUser";
	
	public static final String CMD_ADD_CATEGORY = "addCategory";
	
	public static final String CMD_EDIT_USER = "editUser";
	
	public static final String CMD_DELETE_OBJECT = "deleteObject";
	
	public static final String CMD_ADMIN_ACCESS_GRANTED = "adminAccessGranted";
	
	public static final String PROTOCOL = "http://";
	
	public static final String ROOT_PATH = "/PhotoAlbum-Web/connection";
	
	private String host = null;
	
	private String port = null;
	
	private String connectionString = null;
	
	private URL url = null;
	
	private HttpURLConnection httpUrlConnection = null;
	
	ObjectInputStream objectInputStream = null;
	
	ObjectOutputStream objectOutputStream = null;
	
	public NetworkConnection(String host, String port) throws MalformedURLException {
		this.host = host;
		this.port = port;
	}
	
	private String getConnectionString() {
		if (this.connectionString == null) {
			this.connectionString = PROTOCOL + this.host + ":" + this.port + ROOT_PATH;
		}
		return this.connectionString;
	}
	
	private void openConnection() throws IOException {
		this.url = new URL(this.getConnectionString());
		this.httpUrlConnection = (HttpURLConnection) getUrl().openConnection();
		this.httpUrlConnection.setRequestMethod("POST");
		this.httpUrlConnection.setDoOutput(true);
		this.httpUrlConnection.setDoInput(true);
	}
	
	private Object exchangeData(Object outputData) throws IOException, ClassNotFoundException {
		openConnection();
		writeObject(outputData);
		Object inputData = readObject();
		return inputData;
	}
	
	private URL getUrl() throws MalformedURLException {
		return this.url;
	}
	
	private HttpURLConnection getHttpUrlConnection() throws IOException {
		return this.httpUrlConnection;
	}

	private ObjectInputStream getObjectInputStream() throws IOException {
		this.objectInputStream = new ObjectInputStream(getHttpUrlConnection().getInputStream());
		return this.objectInputStream;
	}

	private ObjectOutputStream getObjectOutputStream() throws IOException {
		this.objectOutputStream = new ObjectOutputStream(getHttpUrlConnection().getOutputStream());
		return this.objectOutputStream;
	}
	
	private void writeObject(Object obj) throws IOException {
		getObjectOutputStream().writeObject(obj);
		getObjectOutputStream().flush();
	}
	
	private Object readObject() throws IOException, ClassNotFoundException {
		return getObjectInputStream().readObject();
	}
	
	public boolean adminAccessGranted(String password) throws IOException, ClassNotFoundException {
		String cmd = CMD_ADMIN_ACCESS_GRANTED;
		Object[] outputData = new Object[] { cmd, password };
		Object inputData = exchangeData(outputData);
		Boolean result = false;
		if (inputData instanceof Boolean) {
			result = (Boolean) inputData;
		}
		return result;
	}

	public User[] getAllUsers() throws IOException, ClassNotFoundException {
		String cmd = CMD_GET_ALL_USERS;
		Object[] outputData = new Object[] { cmd };
		Object inputData = exchangeData(outputData);
		User[] users = null;
		if (inputData instanceof User[]) {
			users = (User[]) inputData;
		}
		return users;
	}
	
	public void addUser(String username, String password, String firstName, String lastName) throws CreateUserException {
		User user = new User(username, password, firstName, lastName);
		addUser(user);
	}
	
	public void addUser(User user) throws CreateUserException {
		try {
			String cmd = CMD_ADD_USER;
			Object[] outputData = new Object[] { cmd, user };
			Object inputData = exchangeData(outputData);
			if (inputData instanceof CreateUserException) {
				throw (CreateUserException) inputData;
			}
		} catch (IOException e) {
			throw new CreateUserException("Cannot create user [" + user.getUsername() + "].", e);
		} catch (ClassNotFoundException e) {
			throw new CreateUserException("Cannot create user [" + user.getUsername() + "].", e);
		}
	}
	
	public void addCategory(Category category) throws IOException {
		writeObject(category);
	}
	
	public void editUser(User user) throws IOException, ClassNotFoundException {
		String cmd = CMD_EDIT_USER;
		Object[] outputData = new Object[] { cmd, user };
		exchangeData(outputData);
	}
	
	public void deleteObject(Object obj) throws IOException, ClassNotFoundException {
		String cmd = CMD_DELETE_OBJECT;
		Object[] outputData = new Object[] { cmd, obj };
		exchangeData(outputData);
	}

}
