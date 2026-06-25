import sys
from PIL import Image, ImageOps, ImageFilter

def create_icon():
    img_path = r"C:\Users\troll\OneDrive\Belgeler\DepremApp\IzgeApp\izge_app_frontend\assets\images\images\logo.jpeg"
    out_path = r"C:\Users\troll\OneDrive\Belgeler\DepremApp\IzgeApp\izge_app_frontend\assets\images\images\app_logo.png"

    # Open logo
    logo = Image.open(img_path).convert("RGBA")
    
    # Make it a square if it's not
    size = max(logo.width, logo.height)
    square_logo = Image.new("RGBA", (size, size), (255, 255, 255, 0))
    offset = ((size - logo.width) // 2, (size - logo.height) // 2)
    square_logo.paste(logo, offset)
    
    # Create a green background (e.g. 1A8025)
    bg_size = int(size * 1.2) # 20% larger for the border
    bg = Image.new("RGBA", (bg_size, bg_size), (26, 128, 37, 255)) # #1A8025
    
    # Glow effect logic
    # Actually, a simple green background acts as a nice border.
    # To add a "glow" we can draw a circle or just use the green background.
    
    # Let's paste the square logo in the center of the green background
    paste_pos = ((bg_size - size) // 2, (bg_size - size) // 2)
    
    # Wait, the logo might have a white background. Let's add a green border around it.
    bg.paste(square_logo, paste_pos, square_logo)
    
    # Save as PNG
    bg.save(out_path)
    print("Icon saved to", out_path)

if __name__ == "__main__":
    create_icon()
