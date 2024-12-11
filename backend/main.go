package main

import (
	"context"
	"fmt"
	"log"
	"minimalstack/parser"

	"github.com/gophercloud/gophercloud/v2/openstack"
	"github.com/gophercloud/gophercloud/v2/openstack/config"
	"github.com/gophercloud/gophercloud/v2/openstack/config/clouds"
	"github.com/gophercloud/gophercloud/v2/openstack/image/v2/images"
)

func main() {
	ctx := context.Background()

	// Fetch coordinates from cloud.yaml
	authOptions, endpointOptions, tlsConfig, err := clouds.Parse(clouds.WithCloudName("openstack"))
	if err != nil {
		log.Fatalf("Failed to parse clouds.yaml: %v", err)
	}

	// Call Keystone to get an authentication token and create the client
	providerClient, err := config.NewProviderClient(ctx, authOptions, config.WithTLSConfig(tlsConfig))
	if err != nil {
		panic(err)
	}

	imageClient, err := openstack.NewImageV2(providerClient, endpointOptions)
	if err != nil {
		panic(err)
	}

	listOpts := images.ListOpts{}
	allPages, err := images.List(imageClient, listOpts).AllPages(ctx)
	if err != nil {
		panic(err)
	}

	allImages, err := images.ExtractImages(allPages)
	if err != nil {
		panic(err)
	}

	for _, image := range allImages {
		parser.InsertOperatingSystem(image.Name)
	}

	for distro, opts := range parser.GetVersions() {
		fmt.Printf("%s %v\n", distro, opts)
	}
}
