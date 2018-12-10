
import os,sys
from PIL import Image

class GraphicObject:
	def __init__(self,fname):
		self.fileName = fname
		self.image = Image.open(fname)

	def width(self):
		return self.image.size[0]

	def height(self):
		return self.image.size[1]

	def show(self):
		self.image.show()

	def makeSize(self,xSprites,ySprites):
		self.xSize = xSprites
		self.ySize = ySprites
		self.image = self.image.resize((16 * xSprites,16 * ySprites),Image.LANCZOS)

	def toSpriteData(self,offsetX = 0,offsetY = 0):
		cropImage = self.image.crop((offsetX*16,offsetY*16,offsetX*16+16,offsetY*16+16))
		imageData = list(cropImage.getdata())
		for i in range(0,256):
			p = imageData[i]
			if p[3] < 32:
				imageData[i] = 0xE3
			else:
				imageData[i] = (p[0] & 0xE0)+((p[1] >> 3) & 0x1C) + ((p[2] >> 6) & 0x03)
				if imageData[i] == 0xE3:
					imageData[i] = 0xC3
		return imageData[:256]

	def generateSimple(self):
		h = open("demo.inc","w")
		h.write(": define.sprite\n")		
		code = self.toSpriteData()
		for i in code:
			h.write(" {0} $5B p! ".format(i))
		h.write("\n;\n")




img = GraphicObject("spcyan.png")
img.makeSize(1,1)
#print(img.width(),img.height())
#print(img.toSpriteData())
img.generateSimple()	
#img.show()
