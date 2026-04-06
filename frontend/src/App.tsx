import { Box, Heading, Text, Button, Stack, Container } from '@chakra-ui/react'
import { BrowserRouter as Router, Routes, Route, Link } from 'react-router-dom'
import ProductsPage from './pages/ProductsPage'
import QuotesPage from './pages/QuotesPage'

function Home() {
  return (
    <Container maxW="container.xl" py={10}>
      <Stack spacing={8} align="center">
        <Heading as="h1" size="2xl">
          Welcome to Stephenbiz
        </Heading>
        <Text fontSize="xl" textAlign="center">
          Professional B2B platform for promotional products and corporate gifts.
        </Text>
        <Stack direction="row" spacing={4}>
          <Button as={Link} to="/products" colorScheme="blue" size="lg">
            Browse Products
          </Button>
          <Button as={Link} to="/quotes" variant="outline" size="lg">
            Submit Quote
          </Button>
        </Stack>
      </Stack>
    </Container>
  )
}

function App() {
  return (
    <Router>
      <Box minH="100vh">
        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/products" element={<ProductsPage />} />
          <Route path="/quotes" element={<QuotesPage />} />
        </Routes>
      </Box>
    </Router>
  )
}

export default App