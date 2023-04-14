/*  BASIC DROP SHADOW SHADER
        Description:    This HLSL shader adds a basic customizable drop shadow behind the entity/image
        Author:         Benjamin Hume */

struct PS_INPUT
{
    float4 Position   : POSITION;
    float2 Texture    : TEXCOORD0;
};

struct PS_OUTPUT
{
    float4 Color   : COLOR0;
};

/*  VARIABLES
        img:                A reference to the 2D image that is being processed
        shadowColour:       Four float values in which the first 3 corrosponds 
                            to the RGB shadow colour, and the last is always 0.0
        shadowIntensity:    An integer value corrosponding to shadow intensity,
                            (255 = opaque, 0 = clear)
        xDisplacement:      Shift of the shadow in horizontal direction (0 = exactly 
                            behind the origional image, +ive = right, -ive = left)
        yDisplacement:      Shift of the shadow in vertical direction (0 = exactly 
                            behind the origional image, +ive = down, -ive = up) 
        fPixelWidth:        An inherited value corosponding with 1/width of the image
        fPixelHeight:       An inherited value corosponding with 1/height of the image */
sampler2D img;
float4 shadowColour;
int shadowIntensity;
int xDisplacement;
int yDisplacement;
float fPixelWidth;
float fPixelHeight;

PS_OUTPUT ps_main(in PS_INPUT In)
{
    PS_OUTPUT pixelOut; // Initializing the output pixel properties

    pixelOut.Color = tex2D(img, In.Texture); // Setting output pixel properties to input pixel

    float2 observedPosition;
    observedPosition.x = In.Texture.x - (fPixelWidth * xDisplacement);
    observedPosition.y = In.Texture.y - (fPixelHeight * yDisplacement);

    if ((pixelOut.Color.a == 0.0) && (tex2D(img, observedPosition).a != 0.0)) { // If pixel is within shadow bounds...
        pixelOut.Color.r = shadowColour.r;
        pixelOut.Color.g = shadowColour.g;
        pixelOut.Color.b = shadowColour.b;
        pixelOut.Color.a = shadowIntensity / 255.0;
    }

    return pixelOut;
}

technique tech_main { pass P0 { PixelShader = compile ps_2_0 ps_main(); } }
