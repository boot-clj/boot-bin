package boot.bin;

import java.net.URL;
import java.net.URLClassLoader;

// Exists solely so we have a type to seal to prevent user code from
// altering our top-level CL.
public class ParentClassLoader extends URLClassLoader {
    public ParentClassLoader(ClassLoader parent) {
        super(new URL[0], parent); }

    public void addURL(URL url) {
	super.addURL(url); }}
