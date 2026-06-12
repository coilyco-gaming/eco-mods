// Copyright (c) Strange Loop Games. All rights reserved.
// See LICENSE file in the project root for full license information.

using System;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;
using UnityEngine.Scripting;

[Serializable]
[PostProcess(typeof(UnderWaterRenderer), PostProcessEvent.AfterStack, "Custom/Underwater")]
public sealed class UnderWater : PostProcessEffectSettings
{
    [Range(0f, 0.25f), Tooltip("How far the image is distorted from the original position in uv space.")]
    public FloatParameter Intensity = new FloatParameter { value = 0.05f };

    [Range(0f, 10f), Tooltip("The speed of the waves.")]
    public FloatParameter Speed = new FloatParameter { value = 0.5f };

    [Range(0f, 10f), Tooltip("The number of waves.")]
    public FloatParameter Waves = new FloatParameter { value = 4.0f };

    [Tooltip("Distortion texture.")]
    public TextureParameter DistortionTexture = new TextureParameter { value = null };

    public override bool IsEnabledAndSupported(PostProcessRenderContext context)
    {
        return enabled.value && Intensity > 0.0f && DistortionTexture.value != null;
    }
}

[Preserve]
public sealed class UnderWaterRenderer : PostProcessEffectRenderer<UnderWater>
{
    public override void Render(PostProcessRenderContext context)
    {
        var sheet = context.propertySheets.Get(Shader.Find("PostFX/Under Water"));
        sheet.properties.SetFloat("_DistortionIntensity", settings.Intensity);
        sheet.properties.SetFloat("_DistortionSpeed", settings.Speed);
        sheet.properties.SetFloat("_DistortionWaves", settings.Waves * Mathf.PI * 2.0f);
        sheet.properties.SetTexture("_DistortionTexture", settings.DistortionTexture);
        context.command.BlitFullscreenTriangle(context.source, context.destination, sheet, 0);
    }
}
