/**
This work is licensed under a Creative Commons Attribution 3.0 Unported License.
http://creativecommons.org/licenses/by/3.0/deed.en_GB

You are free:

to copy, distribute, display, and perform the work
to make derivative works
to make commercial use of the work
*/

using System;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;
using UnityEngine.Scripting;

[Serializable]
[PostProcess(typeof(HypoxiaRenderer), PostProcessEvent.AfterStack, "Custom/Hypoxia")]
public sealed class Hypoxia : PostProcessEffectSettings
{
    [Range(0.0f, 1.0f), Tooltip("Intensity.")]
    public FloatParameter Intensity = new FloatParameter { value = 0.0f };

    [Range(0.0f, 1.0f), Tooltip("TargetIntensity.")]
    public FloatParameter TargetIntensity = new FloatParameter { value = 0.0f };

    [Range(0.0f, 1.0f), Tooltip("IntensityDamping.")]
    public FloatParameter IntensityDamping = new FloatParameter { value = 0.5f };

    [Range(0.0f, 1.0f), Tooltip("WarpIntensity.")]
    public FloatParameter WarpIntensity = new FloatParameter { value = 0.5f };

    [Range(0.0f, 1.0f), Tooltip("ColorIntensity.")]
    public FloatParameter ColorIntensity = new FloatParameter { value = 1.0f };
}

[Preserve]
public sealed class HypoxiaRenderer : PostProcessEffectRenderer<Hypoxia>
{
    public Texture2D displacementMap;
    float colorOscillation = 0.0f;
    float colorOscillationTime = 0.0f;
    float colorOscillationSpeed = 1.0f;
    float intensity = 0.0f;

    public void Update()
    {
        intensity += (settings.TargetIntensity - settings.Intensity) * (1.0f - settings.IntensityDamping);
        colorOscillationTime += colorOscillationSpeed * Time.deltaTime;
        colorOscillation = Mathf.Sin(colorOscillationTime * 2.0f * Mathf.PI);
    }

    public override void ResetHistory()
    {
        base.ResetHistory();

        intensity = settings.Intensity;
    }

    // Called by camera to apply image effect
    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {


        //material.SetFloat("_Intensity", Intensity);
        //material.SetFloat("_WarpIntensity", WarpIntensity);
        //material.SetFloat("_ColorIntensity", ColorIntensity);
        //material.SetTexture("_DispTex", displacementMap);

        //material.SetFloat("_ColorOscillation", colorOscillation);

        //material.SetFloat("filterRadius", Random.Range(-3f, 3f) * ColorIntensity);
        //material.SetVector("direction", Quaternion.AngleAxis(Random.Range(0, 360) * ColorIntensity, Vector3.forward) * Vector4.one);

        //if (ColorIntensity == 0)
        //    material.SetFloat("filterRadius", 0);

        //material.SetFloat("displace", Random.value * WarpIntensity);
        //material.SetFloat("scale", 1 - Random.value * WarpIntensity);

        //Graphics.Blit(source, destination, material);
    }

    public override void Render(PostProcessRenderContext context)
    {
        throw new NotImplementedException();
    }
}
