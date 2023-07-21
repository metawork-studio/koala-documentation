import pathlib
import shutil
from PIL import Image
from pprint import pprint
import os
from psd_tools import PSDImage
from psd_tools.api.layers import PixelLayer, Group

PSD_FILE = 'psd.psd'
IMAGE_DIR = 'images'

if not os.path.exists(PSD_FILE):
    print(f'Cannot find the "{PSD_FILE}"!')
    exit(1)

psd = PSDImage.open(PSD_FILE)


def is_group(layer):
    return isinstance(layer, Group) or isinstance(layer, PSDImage)


def save_images(layer, base_path):
    if isinstance(layer, PixelLayer):
        name = layer.name.replace(' ', '-')

        # if layer.name.find('|') != -1:
        #     name = layer.name[layer.name.find('|') + 1:]

        path = f'{base_path}/{name}'
        png_path = f'{path}.png'
        print(f'Save a layer into the\n{png_path}')
        layer_image = layer.composite()
        layer_image.save(png_path, mode='r+w+b')

        # Convert PNG to JPEG
        jpg_path = f'{path}.jpg'
        print(f'Convert PNG -> JPG\n{png_path} -> {jpg_path}\n')
        im = Image.open(png_path)
        rgb_im = im.convert('RGB')
        rgb_im.save(jpg_path)

        return

    if is_group(layer):
        for sub_layer in layer:
            name = f'/{sub_layer.name}' if is_group(sub_layer) else ''
            path = f'{base_path}{name}'

            if not os.path.exists(f'{base_path}{name}'):
                os.mkdir(path)

            save_images(sub_layer, path)


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

print('Mine images from the PSD file')
save_images(psd, f'{IMAGE_DIR}')
