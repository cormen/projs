#! /usr/bin/env python

import sys

from OpenGL.GL import *
from OpenGL.GLUT import *
from OpenGL.GLU import *

glutInit(sys.argv)
glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB)
glutInitWindowSize(1,1)
glutCreateWindow('GLUT')

print "Vendor: " + glGetString(GL_VENDOR)
print "Renderer: " + glGetString(GL_RENDERER)
print "GL Version: " + glGetString(GL_VERSION)
print "GL Shading Language Version: " + glGetString(GL_SHADING_LANGUAGE_VERSION)
print "Extensions:"
extensions = glGetString(GL_EXTENSIONS).split()
for ext in extensions:
    print ext
