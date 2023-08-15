import enum
import pathlib
import shutil
from PIL import Image
from pprint import pprint
import os
from psd_tools import PSDImage
from psd_tools.api.layers import PixelLayer, Group
from types import MappingProxyType


class CanvasFormats:
    MOBILE = "mobile"
    TABLET = "tablet"


SRC_FILES = MappingProxyType({
    CanvasFormats.MOBILE: "canvases/mobile.psd",
    CanvasFormats.TABLET: "canvases/tablet.psd"
})
IMAGE_DIR = 'images'


class PSDMining:
    def __init__(self):
        self.file_list = []

    # Is a layer is the group(folder)
    def is_group(self, layer):
        return isinstance(layer, Group) or isinstance(layer, PSDImage)

    # Does a group layer has PixelLayers
    def has_layer(self, group):
        for sub_layer in group:
            if isinstance(sub_layer, PixelLayer):
                return True

        return False

    def save_images(self, layer, base_path, format):
        # Save a layer as an image
        if isinstance(layer, PixelLayer):
            name = layer.name.replace(' ', '-')

            # if layer.name.find('|') != -1:
            #     name = layer.name[layer.name.find('|') + 1:]

            path = base_path

            if format != CanvasFormats.MOBILE:
                path = f'{path}/{format}'

                if not os.path.exists(path):
                    os.mkdir(path)

            path = f'{path}/{name}'
            png_path = f'{path}.png'
            self.file_list.append(path)
            print(f'Save a layer into the\n{png_path}')
            layer_image = layer.composite()
            layer_image.save(png_path, mode='r+w+b')

            # Convert PNG to JPEG
            jpg_path = f'{path}.jpg'
            print(f'Convert PNG -> JPG\n{png_path} -> {jpg_path}')
            im = Image.open(png_path)
            rgb_im = im.convert('RGB')
            rgb_im.save(jpg_path)

            # Remove a PNG file
            print(f'Remove the PNG file\n{png_path}\n')
            os.remove(png_path)

            return

        # Create a directory from a group
        if self.is_group(layer):
            # Separate file lists with the separator only if a group has pixel layers
            if self.has_layer(layer._layers):
                self.file_list.append('----------------------')

            for sub_layer in layer:
                name = f'/{sub_layer.name}' if self.is_group(sub_layer) else ''
                path = f'{base_path}{name}'

                if not os.path.exists(f'{base_path}{name}'):
                    os.mkdir(path)

                self.save_images(sub_layer, path, format=format)

    # Clean the "image" folder
    print(f'Clear the "{IMAGE_DIR}" directory\n\n')
    for f in os.scandir(IMAGE_DIR):
        if f.is_file() and f.name == '.gitkeep':
            continue

        if f.is_file():
            os.remove(f.path)

        if f.is_dir():
            shutil.rmtree(f.path)

        if f.is_symlink():
            pathlib.Path(f.path).unlink()


for format, file_path in SRC_FILES.items():
    psd_mining = PSDMining()

    if not os.path.exists(file_path):
        print(f'Cannot find the "{file_path}"!')
        exit(1)

    print(f'Work with the "{format}" format.')

    psd = PSDImage.open(file_path)

    psd_mining.save_images(psd, IMAGE_DIR, format=format)

    with open(f"{IMAGE_DIR}/{format}-file-list.txt", 'w') as f:
        f.write("\n".join(psd_mining.file_list) + '\n')

    pprint("\n".join(psd_mining.file_list))
