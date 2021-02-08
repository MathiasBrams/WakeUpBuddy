using System;
using System.Collections;
using System.Collections.Generic;
using System.Numerics;
using UnityEngine;

public class Player : MonoBehaviour {

    // configuration parameters
    [Header("Player")]
    [SerializeField] float moveSpeed = 10f;
    [SerializeField] float padding = 1f;
    [SerializeField] int health = 200;
    [SerializeField] AudioClip deathSound;
    [SerializeField] [Range(0, 1)] float deathSoundVolume = 0.75f;
    [SerializeField] AudioClip shootSound;
    [SerializeField] [Range(0, 1)] float shootSoundVolume = 0.25f;

    [Header("Projectile")]
    [SerializeField] GameObject laserPrefab;
    [SerializeField] float projectileSpeed = 10f;
    [SerializeField] float projectileFiringPeriod = 0.5f;
    float shotCounter;

    Coroutine firingCoroutine;

    float xMin;
    float xMax;
    float yMin;
    float yMax;

    // Use this for initialization
    void Start () {
        SetUpMoveBoundaries();
        shotCounter = projectileFiringPeriod;
	}
 
    // Update is called once per frame
    void Update () {
        MoveTouch();
        CountDownAndShoot();
	}

    private void OnTriggerEnter2D(Collider2D other)
    {
        DamageDealer damageDealer = other.gameObject.GetComponent<DamageDealer>();
        if (!damageDealer) { return; }
        ProcessHit(damageDealer);
    }

    private void ProcessHit(DamageDealer damageDealer)
    {
        health -= damageDealer.GetDamage();
        damageDealer.Hit();
        if (health <= 0)
        {
            Die();
        }
    }

    private void Die()
    {
        FindObjectOfType<LD_Level>().LoadGameOver();
        Destroy(gameObject);
        AudioSource.PlayClipAtPoint(deathSound, Camera.main.transform.position, deathSoundVolume);   
    }

    public int GetHealth()
    {
        return health;
    }

    private void CountDownAndShoot()
    {
        shotCounter -= Time.deltaTime;
        if (shotCounter <= 0f)
        {
            Fire();
            shotCounter = projectileFiringPeriod;
        }
    }

    private void Fire()
    {
        GameObject laser = Instantiate(
            laserPrefab,
            transform.position,
            UnityEngine.Quaternion.identity
            ) as GameObject;
        laser.GetComponent<Rigidbody2D>().velocity = new UnityEngine.Vector2(0, projectileSpeed);
        AudioSource.PlayClipAtPoint(shootSound, Camera.main.transform.position, shootSoundVolume);
    }

    IEnumerator FireContinuously()
    {
        while (true)
        {
            GameObject laser = Instantiate(
                    laserPrefab,
                    transform.position,
                    UnityEngine.Quaternion.identity) as GameObject;
            laser.GetComponent<Rigidbody2D>().velocity = new UnityEngine.Vector2(0, projectileSpeed);
            AudioSource.PlayClipAtPoint(shootSound, Camera.main.transform.position, shootSoundVolume);
            yield return new WaitForSeconds(projectileFiringPeriod);
        }
    }

    


    /* private void Move()
    {
        var deltaX = Input.GetAxis("Horizontal") * Time.deltaTime * moveSpeed;
        var deltaY = Input.GetAxis("Vertical") * Time.deltaTime * moveSpeed;

        var newXPos = Mathf.Clamp(transform.position.x + deltaX, xMin, xMax);
        var newYPos = Mathf.Clamp(transform.position.y + deltaY, yMin, yMax);
        transform.position = new Vector2(newXPos, newYPos);
    } */

    private void SetUpMoveBoundaries()
    {
        Camera gameCamera = Camera.main;
        xMin = gameCamera.ViewportToWorldPoint(new UnityEngine.Vector3(0, 0, 0)).x + padding;
        xMax = gameCamera.ViewportToWorldPoint(new UnityEngine.Vector3(1, 0, 0)).x - padding;
        yMin = gameCamera.ViewportToWorldPoint(new UnityEngine.Vector3(0, 0, 0)).y + padding;
        yMax = gameCamera.ViewportToWorldPoint(new UnityEngine.Vector3(0, 1, 0)).y - padding;
    }

    void MoveTouch()
    {
        if (Input.touchCount > 0 && Input.GetTouch(0).phase == TouchPhase.Moved)
        {
            UnityEngine.Vector3 playerPos = new UnityEngine.Vector3(transform.position.x, transform.position.y, 0);
            // playerPos.x = Mathf.Clamp(GetXPos(), xMin, xMax);
            // playerPos.y = Mathf.Clamp(GetYPos(), yMin, yMax);
            transform.position = GetPos();
        }
    }

    private UnityEngine.Vector3 GetPos()
    {
        float yPos = Input.GetTouch(0).position.y;
        float xPos = Input.GetTouch(0).position.x;
        UnityEngine.Vector3 posVector = new UnityEngine.Vector3(xPos, yPos, 1);
        return Camera.main.ScreenToWorldPoint(posVector); // / Screen.width * screenWidthInUnits
    }

}
    
