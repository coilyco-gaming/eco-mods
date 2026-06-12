// Copyright (c) Strange Loop Games. All rights reserved.
// See LICENSE file in the project root for full license information.

namespace Eco.Client.Photography
{
    using System;
    using UnityEngine;
    using UnityEngine.Rendering.PostProcessing;
    using UnityEngine.Scripting;

    /// <summary> Binds Postprocessing profile and parameters with the Vintage Shader </summary>

    [Serializable]
    [PostProcess(typeof(VintageEffectsRenderer), PostProcessEvent.AfterStack, "Custom/Vintage")]
    public sealed class Vintage : PostProcessEffectSettings
    {
        [Range(0f, 1f), Tooltip("Intensity. Lerps between original image and effect")] 
        public FloatParameter blend = new FloatParameter { value = 1.0f };
        public FloatParameter tone  = new FloatParameter { value = 0.5f };

        //Override the IsEnabledAndSupported so the shader is not enable when the value is 0
        public override bool IsEnabledAndSupported(PostProcessRenderContext context) => this.enabled.value && this.blend.value > 0f;
    }

    [Preserve]
    public sealed class VintageEffectsRenderer : PostProcessEffectRenderer<Vintage>
    {
        public override void Render(PostProcessRenderContext context) 
        {
            var sheet = context.propertySheets.Get(Shader.Find("Hidden/Custom/Vintage")); //Find the shader and create a sheet for the parameters
            sheet.properties.SetFloat("_Blend", this.settings.blend);
            sheet.properties.SetFloat("_Tone" , this.settings.tone );
            context.command.BlitFullscreenTriangle(context.source, context.destination, sheet, 0); //Send the parameters
        }
    }
}
