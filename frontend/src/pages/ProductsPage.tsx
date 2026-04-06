import { useState, useEffect } from 'react'
import { Container, Grid, Card, CardBody, CardFooter, Image, Heading, Text, Button, Stack, Skeleton } from '@chakra-ui/react'
import { supabase } from '../lib/supabase'

interface Product {
  id: string
  name: string
  description: string
  base_price: number
  currency: string
  images: string[]
}

export default function ProductsPage() {
  const [products, setProducts] = useState<Product[]>([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    fetchProducts()
  }, [])

  const fetchProducts = async () => {
    try {
      const { data, error } = await supabase
        .from('products')
        .select('*')
        .eq('is_active', true)
        .limit(12)
      if (error) throw error
      setProducts(data || [])
    } catch (error) {
      console.error('Error fetching products:', error)
    } finally {
      setLoading(false)
    }
  }

  return (
    <Container maxW="container.xl" py={10}>
      <Heading mb={6}>Our Products</Heading>
      {loading ? (
        <Grid templateColumns="repeat(auto-fill, minmax(280px, 1fr))" gap={6}>
          {Array.from({ length: 6 }).map((_, idx) => (
            <Card key={idx}>
              <Skeleton height="200px" />
              <CardBody>
                <Skeleton height="20px" mb={2} />
                <Skeleton height="16px" />
              </CardBody>
            </Card>
          ))}
        </Grid>
      ) : (
        <Grid templateColumns="repeat(auto-fill, minmax(280px, 1fr))" gap={6}>
          {products.map((product) => (
            <Card key={product.id} overflow="hidden">
              <Image
                src={product.images?.[0] || 'https://via.placeholder.com/300x200'}
                alt={product.name}
                height="200px"
                objectFit="cover"
              />
              <CardBody>
                <Stack spacing={3}>
                  <Heading size="md">{product.name}</Heading>
                  <Text color="gray.600" noOfLines={2}>
                    {product.description}
                  </Text>
                  <Text fontWeight="bold" fontSize="xl">
                    {product.currency} {product.base_price.toFixed(2)}
                  </Text>
                </Stack>
              </CardBody>
              <CardFooter>
                <Button width="full" colorScheme="blue">
                  Request Quote
                </Button>
              </CardFooter>
            </Card>
          ))}
        </Grid>
      )}
    </Container>
  )
}