using System.Collections;
using System.Collections.Generic;
using System.Security.Cryptography;
using UnityEngine;

public class Paddle : MonoBehaviour {

    // configuration paramaters
    [SerializeField] float minX = 5.5f;
    [SerializeField] float maxX = 10.5f;
    [SerializeField] float screenWidthInUnits = 16f;

    // cached references
    GameSession theGameSession;
    Ball theBall;

	// Use this for initialization
	void Start () {
        theGameSession = FindObjectOfType<GameSession>();
        theBall = FindObjectOfType<Ball>();
	}
	
	// Update is called once per frame
	void Update () {
        if (Input.touchCount > 0 && Input.GetTouch(0).phase == TouchPhase.Moved)
        {
            Vector2 paddlePos = new Vector2(transform.position.x, transform.position.y);
            paddlePos.x = Mathf.Clamp(GetXPos(), minX, maxX);
            transform.position = paddlePos;
        }
	}

    private float GetXPos()
    {
            return Input.GetTouch(0).position.x / Screen.width * screenWidthInUnits;
    }

}
