// Copyright (c) Strange Loop Games. All rights reserved.
// See LICENSE file in the project root for full license information.

using UnityEngine;

public class LockEyes : MonoBehaviour
{
    Quaternion startRotation;
    // Start is called before the first frame update
    void Start()
    {
        startRotation = this.transform.rotation;
    }

    // Update is called once per frame
    void Update()
    {
        this.transform.rotation = startRotation;
    }
}
